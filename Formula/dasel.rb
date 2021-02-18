class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.13.1.tar.gz"
  sha256 "6c3110e4e7a23dc0fdd6fab851de7579ac35e70cb1a7eb7056ddda31a4d00c6a"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2ed8bf16a31e3a178be5450da2efdfe48a1863078d7b8ab3685711de141d403"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ac6fc4056c82b7d6f62e7620da2ba173cc185d773b90629c504f7503dca68f1"
    sha256 cellar: :any_skip_relocation, catalina:      "43e5858ea68fbb43cf1090ccfcd3412b6df3f43e12e887d07bff03061e65569d"
    sha256 cellar: :any_skip_relocation, mojave:        "edeefebe727c9bc6bd5cd518bcc342fd29cd683efbbb7bc89f45bd6acc899b9f"
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
