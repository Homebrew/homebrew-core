class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.57.0.tar.gz"
  sha256 "803b6cbd86d49f166bfce70310ff90dd2569221260bcf82f4dd1b05dfa6556e5"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f94642ab5374f46932ebc031f6a9f76b58330607e39f4c29692164d7a5a5de1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ddc4dac7ca3067dffc44db5c60f391e566f9bfaeeb9451c29d31c9f8e498a20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb52f0c123f0b6ced9f7fcbfa2c082db97e0d5f989c7eaa1a6312a35bd179e02"
    sha256 cellar: :any_skip_relocation, sonoma:         "6609ccdd3ffd64ea55a6e70edc4d65ac800f556dbbcdd5c3a200481ac927c482"
    sha256 cellar: :any_skip_relocation, ventura:        "b5c38e657eacc78b10403fdd334ec3dbcebd229fd40a1925ed324e55052b5cfe"
    sha256 cellar: :any_skip_relocation, monterey:       "383b02546d9eaee2d50b3fd2b117c01c91c94baef74a499fc2e461266d824f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180b4c1c76573ab2b7785536496793038128214849f5b6e6c08f7e3cbe41889b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
