class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "b735faf5ef39911c3cfdb5fdcfe4f515e99b0c87f20b6f517ce2451caebfd201"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cdb6234dd26494c0460473e49bdb592efab162b43d520ee95bf2033f4755353"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d9781a975bb6361f6a029615ccf4d34466b73e463eda43be8a56ee0aecd4a88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb18b36e18b67fd55061f787fabbd0d2f77b9f63613bbdad0612ee3f655ec004"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0399c0e3295cd0312cb728f0622d03266f42976fa04641f1170f2727bf45f4b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ff512eb44be8e30ef54ce31e46f0df4a165360c00ff8849be85d52dc65b904e"
    sha256 cellar: :any_skip_relocation, ventura:        "a5abeacf5e28ae7b12ec4fe614b7a8e0b8a1ed079a2f8fd57bca23eb3b096d84"
    sha256 cellar: :any_skip_relocation, monterey:       "945263870f227d640ebbaf0623dd0a8f387a90d1e6c203aab6a82912fb8c241c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e83b13ccd050f3071adc8de05000b1fe7217bec33449694a9b3c25624a6e2280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4d3d12a6e065aa96fff1da500638fa5130f24c9f4570b8a6712a392d633b959"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
