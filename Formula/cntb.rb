class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "1af41e2fe3d8d5341d32b4f01e65120a717c6e198d0752d08850451088a0e528"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c79c0342a41e05d0156138e3ae07d86efab733218a577f7c28cc0469f6d0fbdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ad5d04fedb6154609c4a2f49a72c56e6551e5916701b389646b28c8eec6c23d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "007cfe569350db8f10571c991f5eea1acf98da6521661f21615014f6af87eda7"
    sha256 cellar: :any_skip_relocation, ventura:        "ff4fa0e8be6dd896e77f8f2c04bcad034223b1a9396a7461c1bae963a361fcec"
    sha256 cellar: :any_skip_relocation, monterey:       "a20cbb20de85fdcf327468cb0a9c12d55c8e81c927aeb2b6a84e87804eed6bfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf61bf25fcbd2b82347a492af2f0c3ba75b11b158cc5558be8714d05ca4f46e5"
    sha256 cellar: :any_skip_relocation, catalina:       "5c1de210607773772626774a46f6b1e6664fc929e399c34a4fb34b5bd71b982c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9359bbfe014be23d55e6944a9cba1efb685714768a27e977847e115387a46a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}/cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}/cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https://example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end
