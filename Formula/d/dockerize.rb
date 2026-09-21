class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "6719249089aa1dba9815421a70559cdefab86d633647fbcdecc3aea7b5698beb"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77b1e94afb11cfe08e1d9b52fc0b53e7d5a1515b3358d0a772752e06133286d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77b1e94afb11cfe08e1d9b52fc0b53e7d5a1515b3358d0a772752e06133286d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77b1e94afb11cfe08e1d9b52fc0b53e7d5a1515b3358d0a772752e06133286d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c92fafa60f7ad6206438ab535559ebcd4cb2185aa549203b340a67e1fa45ced7"
    sha256 cellar: :any,                 x86_64_linux:      "b7f73effd96962dd87a6f9dff7db9c208108e1710333c5e6aa0b1635f98d9355"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
