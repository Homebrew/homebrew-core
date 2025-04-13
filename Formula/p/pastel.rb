class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "7848cd6d2ad8db6543b609dece7c9c28b4720c09fb13aeb204dd03d152159dd2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/pastel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e812865926cc13b1568b5d4b1e201d2beb9266a4c4c9c8e3ea484b258938061b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15d534aa1d21c0f2b1a5ef082a24e7ef5ab01d43cc2019e9ac69a1abf0bd050e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57803257b4273b72d306b3a75e8a9caa5187a693a67f62f5044d30f646d8021f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b735957971ed222ad72bf9e6e2aa6da522ec06840667ae398e7d5ff1e38c26f2"
    sha256 cellar: :any_skip_relocation, ventura:       "6a0219597bb7b66fac01792cf31430bccc9fc9491f778d34f7c7885ea48013a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96bb15eb536e16cd183a3482fb3873ee1297fd9a316a1e60ff20152247fa894d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ed39ba06bbc613002a222b647bb81c1280e3630e89c6944bf8758b78216ee5f"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/pastel.bash" => "pastel"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
