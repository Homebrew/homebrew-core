class Percol < Formula
  desc "Interactive grep tool"
  homepage "https://github.com/mooz/percol"
  url "https://github.com/mooz/percol/archive/v0.2.1.tar.gz"
  sha256 "75056ba1fe190ae4c728e68df963c0e7d19bfe5a85649e51ae4193d4011042f9"
  revision 1
  head "https://github.com/mooz/percol.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68c2670697bf7b628e92fdc13fe70b4701e42605079c63358cd41de78a9d470e" => :mojave
    sha256 "5d11dcf9119aa83ea6d45cc1d15eb94bebda00ffd190527bbdae7dddc5879237" => :high_sierra
    sha256 "dac0631f61d1fad12ffed033d16c163a237e6d863bf5350971a8305fbd69c171" => :sierra
    sha256 "e0acd43c0270f0277dc69492da9c31e0e819c2b4bd1ca8f23db012ba2e4e3aab" => :el_capitan
    sha256 "8a46e774ad1128721b2b425f11083d6494101834b887a575f9071c006abab887" => :yosemite
    sha256 "a5c8be8d7e307651de4951384ac2603e7ca932bfffbf9434170a597f801b799e" => :mavericks
  end

  depends_on "python"

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "cmigemo" do
    url "https://files.pythonhosted.org/packages/2f/e4/374df50b655e36139334046f898469bf5e2d7600e1e638f29baf05b14b72/cmigemo-0.1.6.tar.gz"
    sha256 "7313aa3007f67600b066e04a4805e444563d151341deb330135b4dcdf6444626"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"textfile").write <<~EOS
      Homebrew, the missing package manager for macOS.
    EOS
    (testpath/"expect-script").write <<~EOS
      spawn #{bin}/percol --query=Homebrew textfile
      expect "QUERY> Homebrew"
    EOS
    assert_match "Homebrew", shell_output("/usr/bin/expect -f expect-script")
  end
end
