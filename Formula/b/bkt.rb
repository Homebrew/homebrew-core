class Bkt < Formula
  desc "CLI utility for caching the output of subprocesses"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.8.0.tar.gz"
  sha256 "c8b99f4540a3a083368db7d42d6947aa37217b32b443d97972e4536ed9404469"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f208dd72de9d4518a0624dc5cbaefa7edebd76e1b59af107d705ce36ad0ed7c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f43a7716573ea97ca8d771a0aca2d0eeba2f3b4fb0a7c961acd00443fd515a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4918fde1784c5f9857c270c071ca1419db44a34c8750e85313fa96d02cd8648"
    sha256 cellar: :any_skip_relocation, sonoma:         "5474740470603f46600633932c9aea50fc6521aa78231f9663645c03fc3bb039"
    sha256 cellar: :any_skip_relocation, ventura:        "003091dc33df2f6e13ed64cbe9ece53d6b5facb1799b7cb237b878c570e51681"
    sha256 cellar: :any_skip_relocation, monterey:       "1cdcd41e666dc4c82cf59e768ac9a0fbeb47733c07a963d9f27df861d58e4db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8b0cbe97719769610f00faecb17cf49de17b5837b3cb23a102c28b133e0840f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt --ttl=1m -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt --ttl=1m -- date +%s.%N")
  end
end
