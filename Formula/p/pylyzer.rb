class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.42.tar.gz"
  sha256 "e7062b47e17f02790b834c6504bde5b59a4bb129e9b1537a010663bdf5559fab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd23ed3465bc3875210281eee18788e0aecb442f3951f03a67fd1964769e05ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1980be37bdeb6b7238397e3ec943d27324e284823ac78b3288e6cc552618c788"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "603b671b047ec60097e486c6c08f8eab1848d26fff380328ebd5b313cf4e1e85"
    sha256 cellar: :any_skip_relocation, ventura:        "27232e8625474ea398cca94efbb7789e7ea0c7f4d95e49a8e1988dbe767c74d5"
    sha256 cellar: :any_skip_relocation, monterey:       "9745a23670ed70b5e6f694cebc77b761c8a48f4a97f29d5e55b6d444ad960357"
    sha256 cellar: :any_skip_relocation, big_sur:        "42c1565ba95f090666c963da731556560800de95e8aa2ef5d19f32f52ba5c666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c564bf437f9b1a2eb74cef0852ac721cdb8088e3ff7d7d851b263b02bd88ee23"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
