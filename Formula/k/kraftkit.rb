class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "321439fd15bbdb485943899ea1dc6f6693d2cfe56ff275ac2aedd91b807040f0"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30aef9184d1ca3c8c6a4191dbee88abccd2fd61197c9495f3cc245a2c9191676"
    sha256 cellar: :any,                 arm64_sequoia: "9f5c06df76123c9da9e82fea16dcf58a980c40ad59864620051e7ce7effa5c2b"
    sha256 cellar: :any,                 arm64_sonoma:  "d45e52fc22f33de2c77a24a05912e90488603c8f8c41f62dda77f2848cf2aaae"
    sha256 cellar: :any,                 sonoma:        "f857879186e5d0aa37035700898b37fc86172e12880822a4ab14075fc4d07267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8c07510fd699a791553346c8e01020f65ed58ca9e4c441e594e2e69ce29d342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "935a138723c4b2a41b9fb6318e2feecb5ac6905cef911cd6cd2ed5fe731ddbca"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X kraftkit.sh/internal/version.version=#{version}
      -X kraftkit.sh/internal/version.commit=#{tap.user}
      -X kraftkit.sh/internal/version.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"kraft"), "./cmd/kraft"

    generate_completions_from_executable(bin/"kraft", "completion")
  end

  test do
    expected = if OS.mac?
      "could not determine hypervisor and system mode"
    else
      "finding unikraft.org/helloworld:latest"
    end
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
