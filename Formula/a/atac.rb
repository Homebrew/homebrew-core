class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://atac.julien-cpsn.com/"
  url "https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "230fc1730fa8787a390232d88f286ba542e8627426ae9f7897f77d2a728b3578"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d77d486ce20dc189f86e1ef0035987e7a41023d8f2e3aae4400d21134f4ae2aa"
    sha256 cellar: :any,                 arm64_sequoia: "5256db3f3e645117605fed41808add96c55d8c33e6861e5d29984647b7a2d212"
    sha256 cellar: :any,                 arm64_sonoma:  "a045d53a28a6f0ad7813e13f925185a92973e61f94d84ad9eee268ef71058475"
    sha256 cellar: :any,                 sonoma:        "5fa9daaa8f15d443cbef8ef8fe030f00045d211672ff4973754a34eb484c78c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7fcaeb9ad46e445f7021cb8ae79eb4751f323ab19efea0192a59f4da1bed0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b3282d2f3123a70069906d2c78245be6123b363c35598a13d106c158786cf1d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    # Turn off shell completions to clipboard feature
    system "cargo", "install", "--no-default-features", *std_cargo_args

    generate_completions_from_executable(bin/"atac", "completions")

    system bin/"atac", "man"
    man1.install "atac.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atac --version")

    system bin/"atac", "collection", "new", "test"
    assert_match "test", shell_output("#{bin}/atac collection list")

    system bin/"atac", "try", "-u", "https://postman-echo.com/post",
                      "-m", "POST", "--duration", "--console", "--hide-content"
  end
end
