class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "af1091a1813e41869075dea77e180196b4c45bf0f4d8ef9aa7ba5a07df0377de"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "494a4b140bdd0f8d91d8b1660445f5fd4c397201a955c02a77673a7b73cbfc8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab0b1f1f037922e1d1fd8e04e9ac59827656572a745de3d3cde1bbe555b50d6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229b024774c5c2e41f19a38acc945126a54c384aa265763898fce5bcd899e9ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9742351d53eab2650dfa3845dd86d3a7adf210511fa3b7d095061de30bed184"
    sha256 cellar: :any_skip_relocation, ventura:        "4f975924b6a26e7ef52be6cc2951085fd9b694d0789c07f65967da5fa34a653d"
    sha256 cellar: :any_skip_relocation, monterey:       "d85cb419658c22656fc6c692477d49c666e64a9dc7888e8943c0d1890bbe58b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d813a68d9d98ac19d384235ab44b8a75cb29650f5d17072de3e2805d2f38c84"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"moon", "init", "--minimal", "--yes"
    assert_predicate testpath/".moon"/"workspace.yml", :exist?
  end
end
