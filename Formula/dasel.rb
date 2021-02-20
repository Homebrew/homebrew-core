class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.13.1.tar.gz"
  sha256 "6c3110e4e7a23dc0fdd6fab851de7579ac35e70cb1a7eb7056ddda31a4d00c6a"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b014d6b752766ae1fca90543eea7cac5554df87b2b1495589ce1aca76c814ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "77b3b6cfc51fe1fe573970850b434136729abbf3011f1d70240e250724909b4a"
    sha256 cellar: :any_skip_relocation, catalina:      "63e7367ca386d9eb7c2cdc83a6ed64ce169260810d97d9ab333ac1359d631534"
    sha256 cellar: :any_skip_relocation, mojave:        "a53f99cfa2b3516b1bbe8e1eff26aa86d5391b346bff1b3b1d7293e0a102f867"
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
