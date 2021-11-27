class Q < Formula
  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/additional-fixes-for-brew.tar.gz"
  version "3.1.7"
  sha256 "bec6842e5407ecad2ed4c36f27f4814670b193a2ea1c0da5409d2064f06ff93d"

  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c72ca06a7c9dbe3b3eaee1b8db72811edbf7e64fbee5b694bcf2ed7e8d877d50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c72ca06a7c9dbe3b3eaee1b8db72811edbf7e64fbee5b694bcf2ed7e8d877d50"
    sha256 cellar: :any_skip_relocation, monterey:       "4511c183df36704ec7cb497b4a319409875ea2ef6068255ae2a2e0a2d7293e29"
    sha256 cellar: :any_skip_relocation, big_sur:        "4511c183df36704ec7cb497b4a319409875ea2ef6068255ae2a2e0a2d7293e29"
    sha256 cellar: :any_skip_relocation, catalina:       "4511c183df36704ec7cb497b4a319409875ea2ef6068255ae2a2e0a2d7293e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bed14a331133ff96b85fa37e0729ca695bd273f78ee82e792185d137edf9917a"
  end

  depends_on "pyoxidizer" => :build
  depends_on "python@3.8" => :build
  depends_on "ronn" => :build
  depends_on xcode: ["12.4", :build]
  depends_on arch: :x86_64

  def install
    arch_folder = if OS.linux?
      "x86_64-unknown-linux-gnu"
    elsif Hardware::CPU.intel?
      "x86_64-apple-darwin"
    else
      "aarch64-apple-darwin"
    end

    system "pyoxidizer", "build", "--release", "--var", "PYTHON_VERSION", "3.9"
    bin.install "./build/#{arch_folder}/release/install/q"

    system "ronn", "--roff", "--section=1", "doc/USAGE.markdown"
    man1.install "doc/USAGE.1" => "q.1"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
