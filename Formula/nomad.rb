class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.5.5.tar.gz"
  sha256 "85ead33524e847ad02525a038d54ee6ecbbdebcbf364a97f55289ec142101742"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85b9561dcf98d9549f9428716d5b314b79c35106e1d4b7223bcbe365ab791041"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5c4e3ff62d73f620a1da949a137eb8e6b53fd5c33331660be20e3228b43b0c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93798e3f5fa663fd0a389e77c94b78f0638b6f9240944d793dfbeaf83f8acd54"
    sha256 cellar: :any_skip_relocation, ventura:        "fed4d8d9d1278b906b061978e71bd5af333172aea8d90759df5071d184589ec8"
    sha256 cellar: :any_skip_relocation, monterey:       "b80bfce36186e5ecc7bae53b6d3747700472d0249e9878c3f0f219e65b2ecdbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "b045dee26b4718562223098bff7596f451289bae0c460c72dc0ac53f3fed384e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9082e494aad4a4c40d25bd24769fae59d84e6a6697d2935a349a7736e676403a"
  end

  depends_on "go" => :build

  # Fix build on Big Sur. Remove when release includes this commit.
  patch do
    url "https://github.com/hashicorp/nomad/commit/780fcf9043f271caa249c8aceba69338db52dfbf.patch?full_index=1"
    sha256 "67222324f824e18f7a7e4cf83a22d8b759e37e4053dd2c8c2a90772dff5f9ccc"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "ui"
  end

  service do
    run [opt_bin/"nomad", "agent", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/nomad.log"
    error_log_path var/"log/nomad.log"
  end

  test do
    pid = fork do
      exec "#{bin}/nomad", "agent", "-dev"
    end
    sleep 10
    ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
    system "#{bin}/nomad", "node-status"
  ensure
    Process.kill("TERM", pid)
  end
end
