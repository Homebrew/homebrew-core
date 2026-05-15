class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.8.1.tar.gz"
  sha256 "5638c8759899bfc7a5658d44d8cfcf091f0afc001fdcaa5d305a03f6aa668475"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d207da7d9e3694d849795a4674d6580b8aacb80cec69302f5d8d5ea851f6e3b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0883d37e4681202fcd7dadd9f5d7444058b237d0dab41769cfb189e934d32e3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f36198c12bcaa9f5f69db74c84ec064ba81595572981487b7c90c88d7ee3ae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cc3926e677c29785105ac4d314f16195d251a5e807682630ac783c956335de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b5a05a42cb6dec1acb7f35ae87cd419731a45fe323e52e146a59be4d3a6ea72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d5e33ca23813c81b8c5d913de72e78c1dda0c4af11e82091e95b5f7809e971a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
