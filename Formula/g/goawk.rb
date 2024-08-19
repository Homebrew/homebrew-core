class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "f39d5b3ff50f3c16cbfaaa40eb01ec045092afa66988e9728661c65c0e5d6a93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "809461d8c50cf9fc9b71a05e69ca05f4027888bf20d611e2fb0a2b1eaaac642c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "809461d8c50cf9fc9b71a05e69ca05f4027888bf20d611e2fb0a2b1eaaac642c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "809461d8c50cf9fc9b71a05e69ca05f4027888bf20d611e2fb0a2b1eaaac642c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f304b0077853f4a99002a0f4e2f7eb6e9c73500f606a1b4a79987fd39158bacd"
    sha256 cellar: :any_skip_relocation, ventura:        "f304b0077853f4a99002a0f4e2f7eb6e9c73500f606a1b4a79987fd39158bacd"
    sha256 cellar: :any_skip_relocation, monterey:       "f304b0077853f4a99002a0f4e2f7eb6e9c73500f606a1b4a79987fd39158bacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84c5add631fecc6d08aa74e4607a98fc39b1570777763257caa3042eeb027855"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
