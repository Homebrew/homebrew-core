class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.8.1.tar.gz"
  sha256 "5638c8759899bfc7a5658d44d8cfcf091f0afc001fdcaa5d305a03f6aa668475"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae3196c00596806784136909afae180ce3556bc53770ca95c8266324c285f1a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "476cd1bbe57d73e981ac7d93033892ce3a70e507dd4538bbcb3da11d615997f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84c845b11b998c5eba0e275305a19b9c7db52ffefac17b07f8de5253c52bd92b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9de6ad46ac2f152cde3007ab589650442cc5ce9da7d74399c888534bab8dd7bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "58d75af4d61aa6ade3e137c414c4b355949e63835c731db228f939b0e3e20c7c"
    sha256 cellar: :any_skip_relocation, ventura:       "fb996f3b6c85217689dbc99bf94cb1646effb6bc203b5eacf864f862d20046b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32cd6cd48bb96e40477d91f1b0519c30ddf8b26654c0620060a107e931cd999a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "252412dd4df54aa83cfe00168e09b16c2404a1269ce0ae86da3cbdff8d88fbab"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
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
