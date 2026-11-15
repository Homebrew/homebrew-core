class JvmMon < Formula
  desc "Console-based JVM monitoring"
  homepage "https://ajermakovics.github.io/jvm-mon/"
  url "https://github.com/ajermakovics/jvm-mon/archive/refs/tags/1.4.tar.gz"
  sha256 "1fda84dbb8e848c1fe6046468a290ac53fcfeb147db8585d9f4ea2ecbdec0058"
  license "Apache-2.0"
  head "https://github.com/ajermakovics/jvm-mon.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "01f510494d209ae05c088c18cb10aaab7e9a8773d014602098850a196a7d60d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d642e46eb31394c752d72259da9ea93eff02d017cec4e5cebeb4af0ccf06fc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ec8458aea8a3a61085af2f928b83ba20f97e6ac8cbb79abd68df625201102f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "840b2301153d7703088f2cf1530cc780387c2f53495fc1968cb827846f1545c0"
    sha256 cellar: :any,                 x86_64_linux:      "7c4c6bad086318fa9dda63e4eecbd7595ffdce1558f60e87ee7c2c995476353e"
  end

  depends_on "go" => :build
  depends_on "openjdk" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "jvm-mon-go"
  end

  def install
    cd "jvm-mon-go" do
      system "./make-agent.sh"
      system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jvm-mon -v 2>&1")

    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(bin/"jvm-mon") do |_r, w, _pid|
      sleep 1
      w.write "q"
    end
  end
end
