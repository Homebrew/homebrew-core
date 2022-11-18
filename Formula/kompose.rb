class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.26.1.tar.gz"
  sha256 "58547107377705f48cd02e391a5faf441dc0c861aeb9bc17c7c46e9de3ae1806"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dadc4cde7ba351d065c9b8acbd20698d2f65787075ed8d0130280435f6ba45dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fce20c79ca7c5ec23d04804d5f0625796a9ae5bf2ff8f3c2dd6ebf6c9091039b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7608ab8e23169c6c25b6da42713a7ef7aa078d09b63bcd748949800a0a3c6bd"
    sha256 cellar: :any_skip_relocation, ventura:        "c69653bc07ecfe1ede9ede3fd18fa9c324c22cbf11acae0c866f99dc9694bb8a"
    sha256 cellar: :any_skip_relocation, monterey:       "d900c5a6242038bbaf31560418d16f6b66790b7f4f9206415da2853276a1a137"
    sha256 cellar: :any_skip_relocation, big_sur:        "94764694cbc83e31edc3df3f8588327159cdba7ff2658ea9786e118b5a792e11"
    sha256 cellar: :any_skip_relocation, catalina:       "975b28f3cd25872551219403be36825d38585a315f5c1f3ad5812d7be4e2913a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efb804b13b812975bb6995e458bd1a1404d26b836a47cd244031a362ce6c894e"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
