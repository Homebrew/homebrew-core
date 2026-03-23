class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  # homepage bug report, https://github.com/tcnksm/ghr/issues/168
  homepage "https://github.com/tcnksm/ghr"
  url "https://github.com/tcnksm/ghr/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2428daa1de7e03850349994e49857e336cb5cabc882ed4b9261f9aba87a9dc9e"
  license "MIT"
  head "https://github.com/tcnksm/ghr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f4f4fc3b527be585c72a31a66f22ea8354f9f90e8d663055f2ad22ccaf5869a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f4f4fc3b527be585c72a31a66f22ea8354f9f90e8d663055f2ad22ccaf5869a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f4f4fc3b527be585c72a31a66f22ea8354f9f90e8d663055f2ad22ccaf5869a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e861c7fb1499758baf3d0a5cde1b2e7c406b26481242eb85ad10c837514ad57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c81cc7471402c35c0fa7d35d9c14788b3e76f89d9889b02c02a0c60a66084670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c552e786a40e5ebdbb6e8a459b2154e9ada5db8c7d803f8ce5b05181344eab7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
