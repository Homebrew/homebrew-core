class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.117.tar.gz"
  sha256 "bba84a6964ac87021b9372eed50ce5b9bd6ea3fcfbb9c74cf0088b7b467d628b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9032439a784af083a8cb10182204a5ea90b8db9886f54cee28c0670a104aff68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96b6f4cde68bf54d51c528098cade2a3921a02f02fe403561e38e04ccd46c559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71d29aacd64e851a525850c22fdef83bd73db38ac4bdc335d9f0c7bf5afcb6cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ebcf3869b2fc40040def0fc305d8cffb9bb8061c1387ec42edfb83402f01803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c0e3099c65f899631fb47057f3952a5bbd9e4a81f51063ec3925d19868623dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "781cf942b69dc10f1413b8bd45483880bf50323b0871954a23773c0ba68f5513"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end
