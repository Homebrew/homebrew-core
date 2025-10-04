class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.6.tar.gz"
  sha256 "0e57d021f5068482aaf10ec8d2fa90a94632be6110eea637210cc1f908ebdc4c"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05221ebbe46bce8c193db485fa9fc539a85fe7ca3b53697d71dcd064bf3e1c21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82280448e8aa946fd7f741b4d1e35d41caa539335e218fbead503ab3732e0f21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c08ef5f336295b3d37bc6e8e338417fd4737174ca991fc9559491bff9f85a102"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a32c56f28f3f596fa4cbb0a7384fea382a24449be5f601d0ef927be8770eda7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36f5ddca20df0d208434fb138ffaef7da6677582c990919cafe7f6d14e3a55b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7577a23e23b52181c5cba1aa9108655e909f2ad66559a8e1236b2a92f624aa06"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    ENV["BINSTALL_DISABLE_TELEMETRY"] = "true"

    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
