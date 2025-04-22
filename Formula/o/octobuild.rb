class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.7.1.tar.gz"
  sha256 "74149cdbb04f1b854064345270dd83b85dab3f3a6276d46e2d0a11d53d0651f2"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f127d2f870e05b0ac8cd451bd85f87beaa58d275bc30ae555766fbeaa9ce6673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95304df2c60232abf3aed763198f5820a70f405b9fd857ead01680135b5d0f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e28de2bd21191ed3cc1bf3480da02c4e9176ec4991d58fc7eb61d7c0f83ebd80"
    sha256 cellar: :any_skip_relocation, sonoma:        "33612f8a07e682ca29a89d541c17420bcaede31cccc382bef86333eaa792e82e"
    sha256 cellar: :any_skip_relocation, ventura:       "daa1e485d69f56da61fa011c64fc6c02304ce76eb620bf57346fbafc02fb9410"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e98eedd1407f8d025d8f0218b3519914e5fce1120adea89b14a3aa2ee6ba9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300255c2f90b74d17ad4abe23ad79e3729e602a7f69d1a0b2bd3d68f2e96eec2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  resource "ipc-rs" do
    on_linux do
      on_arm do
        url "https://github.com/octobuild/ipc-rs/archive/e8d76ee36146d4548d18ba8480bf5b5a2f116eac.tar.gz"
        sha256 "aaa5418086f55df5bea924848671df365e85aa57102abd0751366e1237abcff5"

        # Apply commit from open PR https://github.com/octobuild/ipc-rs/pull/12
        patch do
          url "https://github.com/octobuild/ipc-rs/commit/1eabde12d785ceda197588490abeb15615a00dad.patch?full_index=1"
          sha256 "521d8161be9695480f5b578034166c8e7e15b078733d3571cd5db2a00951cdd8"
        end
      end
    end
  end

  def install
    if OS.linux? && Hardware::CPU.arm?
      (buildpath/"ipc-rs").install resource("ipc-rs")
      (buildpath/"Cargo.toml").append_lines <<~TOML
        [patch."https://github.com/octobuild/ipc-rs"]
        ipc = { path = "./ipc-rs" }
      TOML
    end
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
