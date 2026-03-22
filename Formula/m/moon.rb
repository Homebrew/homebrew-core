class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "40c287ab51da015f50c9afa9e1fbce6914926be4113277dd1c2407e4aa5d448a"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48b49d915bf8ef74acbd067b8ba70c0b9b9a752f44a500b226e85b125c556b1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03aac3a00ff0333a8b41fff97a68ef0cdf4618920a951108243bab39c8a116ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b5478b27aa21d4a24b1af6b11366e99b258a099bfea447043ace383116fb9ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "93a03ebf5a13fcef760eaf5b073bb182fff04752dec2270085fbf6343f7a1bf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dcca2012688e809c816537d36842116b8059b0da604f4c5603b7d7fd877deef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3043a6936e5f2be7c033a6c70576096dea79c5a6ba66da40ae84b2cd0c9b3df"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

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
    assert_match version.to_s, shell_output("#{bin}/moon --version")

    system bin/"moon", "init", "--minimal", "--yes", "--force"
    assert_path_exists testpath/".moon/workspace.yml"
  end
end
