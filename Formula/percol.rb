class Percol < Formula
  desc "Interactive grep tool"
  homepage "https://github.com/mooz/percol"
  url "https://github.com/mooz/percol/archive/v0.2.1.tar.gz"
  sha256 "75056ba1fe190ae4c728e68df963c0e7d19bfe5a85649e51ae4193d4011042f9"
  license "MIT"
  revision 2
  head "https://github.com/mooz/percol.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e09b635ba6745c7beacd38c6a48d3d8637d0894618fc4e4ce1fdd8113d227cea" => :catalina
    sha256 "e09b635ba6745c7beacd38c6a48d3d8637d0894618fc4e4ce1fdd8113d227cea" => :mojave
    sha256 "e09b635ba6745c7beacd38c6a48d3d8637d0894618fc4e4ce1fdd8113d227cea" => :high_sierra
  end

  depends_on "python@3.8"

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
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
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
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
