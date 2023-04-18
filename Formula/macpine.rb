class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v0.10.tar.gz"
  sha256 "bca9075958cb76a79cb66f848a44f6ff8f2c1493d6af0b79e871b4457f1fe4d1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3b230879c573dffd93ad1bbef479f5d392503daa120778714a5c45dd6c07505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "689441f80671c1c58706b1210310d3e7b870305c66a86ab824a570b32abc9a47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ec5561d896636b6cc45f05652ec744116c82b61fd0720499dc8f8bce0dab953"
    sha256 cellar: :any_skip_relocation, ventura:        "3f08d3a9ab655d9a200be0bee68c6eb9d99161eaa72bf46a4bad727f517df225"
    sha256 cellar: :any_skip_relocation, monterey:       "19f20689e113586bb3fa51af27c55e724688f701aa46c5232db02a42022a008d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b364ef8e8f862de2c3717da36bb864837609c7702bacfeda4285d79990ffd204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7b233348afcd4cc8c59414074fa0c2338c4658b7d39c87435fee7741655dce"
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
