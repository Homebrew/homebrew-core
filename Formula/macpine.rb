class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v0.9.tar.gz"
  sha256 "fbbed218de0037d0fc82bc675fbe89b44202f757f12a5ab53f32ff70345ee1c2"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)*)$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        version = tag[regex, 1]
        next if version.blank?

        # Naively convert tags like `v.01` to `0.1`
        tag.match?(/^v\.?\d+$/i) ? version.chars.join(".") : version
      end
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae25520460c488e1bd6d2cf9e3137a6dea39356f6f07ee2e86b2f516d0560c4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7efd71cf4578bf9abe3ce07202eb62d7e43087751bd98e15c566978283d5192b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40a28553c4c47e3b5fc264d41d7f468fc10ed8f585b5e7ea6ea8e12351f8bbf2"
    sha256 cellar: :any_skip_relocation, ventura:        "5dbe2d92fe49d24b7bbddfeb54e0cc28e4df024227d28f55443dba532f7589e1"
    sha256 cellar: :any_skip_relocation, monterey:       "5a1326dc4664559743bb31f0c37c2de9c57783793ce1d889bb3269129316a5c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "126db80dd234e69a8e7e60af5557932ea8647748870b1c210e059e0acc6ea8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c294e421b90228e402c66017909669ce94717bf4fb5499347bd764c2e680082"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    generate_completions_from_executable(bin/"alpine", "completion", base_name: "alpine")
  end

  test do
    assert_match "NAME OS STATUS SSH PORTS ARCH PID", shell_output("#{bin}/alpine list")
  end
end
