class Papeer < Formula
  desc "Convert websites into eBooks and Markdown"
  homepage "https://papeer.tech"
  url "https://github.com/lapwat/papeer/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "8055548c34cfe21a993e41339a94f2fcb3c88cb27aeeaa2d3df3e6f63d2b1aff"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8778c94187605165f90672abdef21ed925ae452bc9fbfd96c3d3c7113ca6369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8778c94187605165f90672abdef21ed925ae452bc9fbfd96c3d3c7113ca6369"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8778c94187605165f90672abdef21ed925ae452bc9fbfd96c3d3c7113ca6369"
    sha256 cellar: :any_skip_relocation, sonoma:        "78b781f8cb851cbf0ec770b898b87f10698a8dde95a890e6c44dbf0f92e7e0ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e252dbf3abfee873b4bec0c119e4a5fd3393dc5a15a9272a3e9bdfb90ab0c68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94d5180edd9948ef214b562ad6e566733e1b0b4dfa80ce67ac8c097b9868dc13"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"papeer", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papeer version")

    output = shell_output("#{bin}/papeer list https://12factor.net/ --selector='section.concrete>article>h2>a'")
    assert_match "8  VIII. Concurrency", output
  end
end
