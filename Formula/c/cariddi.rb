class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://github.com/edoardottt/cariddi/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "9a33ebf9324c3f7f28c72161c80c994eaa3ca495c487eefed39a2e6861d65674"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f556c527c702d41a7afff38b79ab305eb476c78ebdc461e70d0023b5bae2f9c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f556c527c702d41a7afff38b79ab305eb476c78ebdc461e70d0023b5bae2f9c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f556c527c702d41a7afff38b79ab305eb476c78ebdc461e70d0023b5bae2f9c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "40006b92d08b3aca057d49d04fb850dbdffde802eeaa24f8a12875ac1ab10079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04ccc2f10cd2316b1f5c391056987f1d8cd80bef0c48e6f98744017569319abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "819cc7c9a7663628fa0b8a68fd63fe4f308b52b914ecebb5443263be13d1cf4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output(bin/"cariddi", "https://brew.sh/")
    assert_match %r{(https://brew.sh/*)}i, output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end
