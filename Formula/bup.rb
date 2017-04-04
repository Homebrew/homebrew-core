class Bup < Formula
  desc "Backup tool"
  homepage "https://github.com/bup/bup"
  url "https://github.com/bup/bup/archive/0.29.1.tar.gz"
  sha256 "d24b53c842d1edc907870aa69facbd45f68d778cc013b1c311b655d10d017250"
  head "https://github.com/bup/bup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffe848617a641266d6915ce1c0fa6713dd02d978f47da33ffb9b91b15adbbe05" => :sierra
    sha256 "d17a4b3cfa4233179a4828b23fdae5bf19a8bb605080c697b52d548354e797cb" => :el_capitan
    sha256 "462b39a188a6fd32d9df4812a629b3bf8692f38439125d98e58e306261277903" => :yosemite
  end

  option "with-pandoc", "Build and install the manpages"
  option "with-test", "Run unit tests after compilation"
  option "without-web", "Build without repository access via `bup web`"

  deprecated_option "run-tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  depends_on "pandoc" => [:optional, :build]
  depends_on :python if MacOS.version <= :snow_leopard

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"
    sha256 "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b6/fa/ca682d5ace0700008d246664e50db8d095d23750bb212c0086305450c276/certifi-2017.1.23.tar.gz"
    sha256 "81877fb7ac126e9215dfb15bfef7115fdc30e798e0013065158eed0707fd99ce"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/5c/0b/2e5cef0d30811532b27ece726fb66a41f63344af8b693c90cec9474d9022/tornado-4.4.3.tar.gz"
    sha256 "f267acc96d5cf3df0fd8a7bfb5a91c2eb4ec81d5962d1a7386ceb34c655634a8"
  end

  def install
    # `make test` gets stuck unless the Python Tornado module is installed
    # Fix provided 12 Jun 2016 by upstream in #bup channel on IRC freenode
    inreplace "t/test-web.sh", "if test -n \"$run_test\"; then", <<-EOS.undent
      if ! python -c 'import tornado'; then
          WVSTART 'unable to import tornado; skipping test'
          run_test=''
      fi

      if test -n \"$run_test\"; then
    EOS

    if build.with? "web"
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(libexec/"vendor")
        end
      end
    end

    system "make"
    system "make", "test" if build.bottle? || build.with?("test")
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="

    if build.with? "web"
      mv bin/"bup", libexec/"bup.py"
      (bin/"bup").write_env_script libexec/"bup.py", :PYTHONPATH => ENV["PYTHONPATH"]
    end
  end

  test do
    system bin/"bup", "init"
    assert File.exist?("#{testpath}/.bup")
  end
end
