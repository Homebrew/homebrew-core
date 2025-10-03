class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "4f35555e19c8a1a05ceba6a7043088a00fea3fbf780bbd4af90696172ce9f7c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b9cc295c306de2a6bd64bb84980bb5a20b6ba873aba1b30b6c429b10bd993c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3a491f06efb90a2897916be0b7196e80a4ff4d9cd79ad005756f05a0b35872e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae8934b2db6234e18f5ef6e726dedc9e8c06c4b861710b0d563806bcb19cd529"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "894749ccb8da73ac24530b365159a6fc10447c2ed49f12bc7392f51542b9122d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4db1eb1ba6ab5dd1c01ddfb42b58048ef197c4ed1f519accbd3558351b075e96"
    sha256 cellar: :any_skip_relocation, ventura:       "f91c9830a4d3cc5509b0c199bd51bace0967e0522a29a55bd397c77d61482fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "130d2791233e9c52929599866aa2adb1f16c59e7b0dd4a8d30b247309fd5c6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18914a7462ceff715a7285b9be16a913a2387dc0a89e7cdb4c626ea625eb4f11"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  # Fix to version bump, should be removed with next release
  patch do
    url "https://github.com/PaddiM8/kalker/commit/bff6f279634aec9a60ec866c1e3f137b9ba1a007.patch?full_index=1"
    sha256 "e74ab1f67fc678e4b6d8bf04dee5893ceba0378b2f079459c397027496cfe5b1"
  end

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalker -h")
    assert_equal "= 15", shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp
  end
end
