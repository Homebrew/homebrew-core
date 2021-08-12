class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.18.0.tar.gz"
  sha256 "70ffd37287648de2171bc60c37e2144240276136242ec861d663090c9b27ce6d"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dd935a4c40b1b4b1eb40999453c10ae4773594e3f094642ccaa5cba7a1b31b24"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a5664e93bf4587cbe1c26aca1830d82c4228ff1b3b9998902479215c2bf6a14"
    sha256 cellar: :any_skip_relocation, catalina:      "160baa77a00feca0a091d24d9326c8c2964059d8346459e366120a4740c0e627"
    sha256 cellar: :any_skip_relocation, mojave:        "47b1b67f1e5718cedb863f57947a0ae4b42490a49765df8aac7e5f6c84e2b5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73fde79b675ea3064c0d5556d941f0a6d6d0d0c956fa2b3ec25ab1d78bb24919"
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
