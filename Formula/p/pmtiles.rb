class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "31573a3fa6e74c684355459a639b1b509f16732e2c5e1c73d8ba9e88e2e52a86"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9920aca1ebe7f9ac196ce1bc3a4262626881dc0d10e483617cbebefeaf230b73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fb0e8aff15f6bc6db4797cd42afd5d031c600ef65d1ca2dd05a2b75e8fbf466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aafb63c3aee00c9d4ebcc358e940fc69839c45fcc4882f5e7a8fdd97f7573c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab331b8efd354a5148167b23fc8561db4cdb1bf6bf3fda183dc726a8b8328fbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "473b9ad9c577cf74267b068360b1f7ead50bfdc8ce542d2b098dac9e66db7af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a614d0b189f217858a9799eb6407ddf8feb82ca8b8566f9aae02efbea60e1bb8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    pid = spawn bin/"pmtiles", "serve", ".", "--port", port.to_s
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end
