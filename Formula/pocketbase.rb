class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "129a53180a084c37b696686c19b2dd05c3eaeff74bd9ad428d86f3cb3eac70aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "162c0569fa1fcfb92b2a541e09d29fdd47fc0d04e6678cd0d2d52be5c88d126b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "162c0569fa1fcfb92b2a541e09d29fdd47fc0d04e6678cd0d2d52be5c88d126b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "162c0569fa1fcfb92b2a541e09d29fdd47fc0d04e6678cd0d2d52be5c88d126b"
    sha256 cellar: :any_skip_relocation, ventura:        "853f4e7ff89ec33ee7cb221575f116aa7d629e976d91af76b7f4ffbd32c01011"
    sha256 cellar: :any_skip_relocation, monterey:       "853f4e7ff89ec33ee7cb221575f116aa7d629e976d91af76b7f4ffbd32c01011"
    sha256 cellar: :any_skip_relocation, big_sur:        "853f4e7ff89ec33ee7cb221575f116aa7d629e976d91af76b7f4ffbd32c01011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "901dc8381dcfa17b6a3b905b13c4be876a53da935c280d5f4e548cc03f731eec"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    system "#{bin}/pocketbase", "--dir", testpath/"pb_data"

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end
