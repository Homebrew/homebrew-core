class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v2.0.3.tar.gz"
  sha256 "5741343829f2a6e1d531b2219b5bace2efa73ff29f02f75d842c087ac05e3aa9"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "mongocli-master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7bc59192df868a8c0b2750fbbdaaa4957a1ba2b90cd4087562187adf37f288f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b53272dff445d77cd667bca6d1b4e34d56f771163b65a77e43ff309db07d697"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e6260fb21c5249bcd455d3421cec294ab6102231a73f6ae51e0412ef8021a38"
    sha256 cellar: :any_skip_relocation, sonoma:        "47319a29447f326f1f52c6b330585cef4fceb474ea1e31611a27d5298ab7d5c7"
    sha256 cellar: :any_skip_relocation, ventura:       "13f66b5e780fda1b5b75a478e291b08028b5938145dc946ae9541d32a010d632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "473378f2ac3d2b3ecd1c6ce7722282b97c0b0c98786a6d21f6a816c25b8eb827"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", "completion")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
