class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.7.2.tar.gz"
  sha256 "8917f689546d590442a0720f09b4a30485b4ca660a63427cd2851d7e977ae794"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcf28ddedd6966f418a0261937675783fdc28b05b039110ad12c303c5461dcf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb47d1bfe2700c29530168a58e6a891886e3b9c2f3a116995f9166424bae6efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8195cf1ddc828a99454636f95333cc9fd697af4bb3403d5ebdf7ff1e79227f02"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd15daa3735cc44f80697b2804d13c980dcade0849ba1551e518ddee28e2cacf"
    sha256 cellar: :any_skip_relocation, ventura:       "f636e240f0593534d816805fa35d40dd1a189d234c5ca19c99be3b45ddd09c8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eaa98da0a1213bc41b5452d2816d5a8a98a5bdf2c474b0e22f986dc59f15e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3362d910f2f9b447046d75f7feb044b679c35bcb1991597b1e0320fc24f9a695"
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
