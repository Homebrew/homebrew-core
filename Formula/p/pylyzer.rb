class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.54.tar.gz"
  sha256 "26a9fdf80bb97f09549be42560cf5aa8d67bd8f1f2484b0960c854edf44f7a68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b56374a09fa5aa9e6f937c49bc8b665cefe3028777857b8f2d8843a57442a500"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db86483d930cd5f5672161ac68e40e24cac02d55735ae6da93cf1270c5c5f67f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efa0da3a09cb782603ce05869fba55760889557758bce0fb6a1380b3edfdf7dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a28360f8967026c4ac4146fb46f33685b575bfa3380a569a33d8e9f7198f4725"
    sha256 cellar: :any_skip_relocation, ventura:        "a6ac585c42234b52ace3529203604c45586c5402825bd4feef20014829bcf5cc"
    sha256 cellar: :any_skip_relocation, monterey:       "c35c50dd7cce0837434c87e93ae5d01211ae2a33cf0d770a8973ae7d64bd2165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e15da58c0f3e4ef445d508943525035497dbe6622de5e55279949fad547ddd87"
  end

  depends_on "rust" => :build

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
