class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  # NOTE: Do not bump to v1.7.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/nomad/pull/18187
  # https://github.com/hashicorp/nomad/pull/18218
  url "https://github.com/hashicorp/nomad/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "8f6f0c2759654b10f64a185ee35c33f221fe662a6a2ba800f7339d955bbec8e5"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "31470c7ad52709c0483c07b31d915d1247759b9d7b900aeba8e909d892bd54a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57af75515a8706b2bf7229d144870f017890bf41f11dd908af028e18dabc75a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed444abdde4adcbf77a5c91ebbe57cd40de9f9275b57772b7a5d2abc42c3ba1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e85355b125037326086493552b1af5c8b6079b92e5ab272d38949ee756315ca4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d1502e3b25a243f1aafb47d3d251271691f53e672f9561a17c67fafc9282741"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ff7924f9708395e40faaf842996971fe0383c3e2addbdc2b5ed32bc28f4d8f7"
    sha256 cellar: :any_skip_relocation, ventura:        "40c38a4e90bbcad4b67ea3f0402968fb48bd4e4e8a27fc888bb686470559e3dd"
    sha256 cellar: :any_skip_relocation, monterey:       "0e093b904787ccdcd37af3f127c16fbb2482c77bc1f9de77bf4c0df5b3bce4cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e247a13f25c6bf03e21e21567484dab364337864661b3a0728879527974ca20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23763707912294f817844f4442751351ff8a294748f8d46ca81f29d7187e926d"
  end

  # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
  disable! date: "2024-09-27", because: "will change its license to BUSL on the next release"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "ui")
  end

  def caveats
    <<~EOS
      We will not accept any new nomad releases in homebrew/core (with the BUSL license).
      The next release will change to a non-open-source license:
      https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      See our documentation for acceptable licences:
        https://docs.brew.sh/License-Guidelines
    EOS
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
      exec bin/"nomad", "agent", "-dev"
    end
    sleep 10
    ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
    system bin/"nomad", "node-status"
  ensure
    Process.kill("TERM", pid)
  end
end
