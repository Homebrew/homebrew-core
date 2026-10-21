class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.127.tar.gz"
  sha256 "8b462a65b4f3291c99ca7312447e0b7550654a02d8964d4000612447e6870b6d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00a80bd332605a3c6aa41cf121d8129164902bb5957e0efae6e1161e6c862e3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "80f05b65ec49fbdd451b74bec72654a06d48cbcf95dd4288cb0298221741022a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df58cf81963aed4fb58b4956f07e39c9bbc84b0c202d112582cc3d24dd4452a4"
    sha256 cellar: :any,                 arm64_linux:       "d71c5a15785b42bbd5d297cab7e2f95f9b9cb19be3b67aedb7d9e73998095bbe"
    sha256 cellar: :any,                 x86_64_linux:      "ec3c1b83117b2bdcf2b14ce0cb7f9094e1e09dcd6393ecfaef118a866031ff84"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end
