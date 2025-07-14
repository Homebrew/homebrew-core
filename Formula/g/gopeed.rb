class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "be643c2b50abd5899b52b9936b1ddd4e29514d82d6b9f41b7530733e694d92d2"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d59f17eadf1e81744bead5012173b2896af1be945d99f786f74f7d4904b4ff1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d140488daa719ee6a81b6a4c41f7a1edb7459e84edc86ea6149767e75a68318b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31aab0270bea07e5500f88e971f67a9adc89b9108e59f6b49185ae68ddc548e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd202d89139bdcb6cf079d6da36d747ab2cd03b6a6aff9aab9c0ff919c4f0bd5"
    sha256 cellar: :any_skip_relocation, ventura:       "26df3709463646d3441f1c4db93709a03fed5edfe9a741d5cba800f2af3272b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ec24f41b6edb2e3710d7491ada8a9a32247abb3b0b5a4c57e89f2d488b48bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138051dd5ef883b73f2e40d9351c11f2c8d83ff9f23c9db6771477cd79f9ef37"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
