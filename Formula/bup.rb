class Bup < Formula
  desc "Backup tool"
  homepage "https://github.com/bup/bup"
  url "https://github.com/bup/bup/archive/0.29.2.tar.gz"
  sha256 "7f54503f305eab5db5db41e1825477b8804870ca251f65bcfb4d89ad2598574f"
  head "https://github.com/bup/bup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ca4593db392b93bad33bd522b2fd5c37bae9966b606e4c62a0fd8997901f1f0" => :mojave
    sha256 "3a1eb0bb1d6f5e4da3e1afe9565d19d1be8eb455ceb20ef404b8c042ce416aa1" => :high_sierra
    sha256 "81d72623d910ba47d6960b4bbc65e214aa9fdb41639d800dc850a5ad8981a5d7" => :sierra
  end

  depends_on "pandoc" => :build
  depends_on "python@2" # does not support Python 3

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"
    sha256 "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/b6/4f0cefba47656583217acd6cd797bc2db1fede0d53090fdc28ad2c8e0716/certifi-2018.10.15.tar.gz"
    sha256 "6d58c986d22b038c8c0df30d639f23a3e6d172a05c3583e766f4c0b785c0986a"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/e6/78/6e7b5af12c12bdf38ca9bfe863fcaf53dc10430a312d0324e76c1e5ca426/tornado-5.1.1.tar.gz"
    sha256 "4e5158d97583502a7e2739951553cbd88a72076f152b4b11b64b9a10c4c49409"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # set AC_CPP_PROG due to Mojave issue, see https://github.com/Homebrew/brew/issues/5153
    system "make", "AC_CPP_PROG=xcrun cpp"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="

    mv bin/"bup", libexec/"bup.py"
    (bin/"bup").write_env_script libexec/"bup.py", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end
