class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.13.4.tar.gz"
  sha256 "a3f68ca90d518040638e81d9e71bb7420719893700ba4a771a236462a25d474d"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8054cddd2e629d52ec392db73b330cbe0fa025fb8d07ab56310dc07be632f8cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "eef50328edda76719ddfbd5242171db1e48deb279f387f86665d4838c18bb0a3"
    sha256 cellar: :any_skip_relocation, catalina:      "8014955eec7714368bbeabbcc838d017e98701b7f5f11e2b381677da46d0b18c"
    sha256 cellar: :any_skip_relocation, mojave:        "0b4547c9ede1c4cd8a73ce05cb1e194d92331f2b238f6c31d280966056c43742"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
