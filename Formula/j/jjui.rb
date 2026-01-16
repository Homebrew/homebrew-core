class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "2bb02c22f1164856909152a7f13aaa24b8e97169b8377c711d4682fd32d8d85b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e52f6426042f9681f38e705a7d1d2b9f97ccd87715e3e3a3055488223a346bfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e52f6426042f9681f38e705a7d1d2b9f97ccd87715e3e3a3055488223a346bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e52f6426042f9681f38e705a7d1d2b9f97ccd87715e3e3a3055488223a346bfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec3bdf0550bf9385e439ddf5dbd81e79ddc7389cb967434c5e1b10e8b7b266bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "511a532ccd915c2a7ee4ee04348481421266107c9faaa4959ba1fe22d55ac659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c65f766e6b41098349f3ac2cf0606e0e7e7a897601d8ab756692aa00cf507f7e"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
