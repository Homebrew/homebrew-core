class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.50.1.tar.gz"
  sha256 "cee85ca10b7d98ecafde0ec7feca0e891f29df0e132475ae353fb23f23b4509c"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "601386619f59cbe3220161ab417a4dda44d84ea499ed1c047c0cf7de9be6bc78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "691be794de9119744e71e8d50047b8634ff9285c9f88cb15c87cc8a42dc60e8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4ee22b9064966f2af79d83148c2d1530f857438f91a213d54efd16e0a19901e"
    sha256 cellar: :any_skip_relocation, ventura:        "04b0f7fb30c508f779f9dc252dac5e07471035136d2788789050bb568436fbd2"
    sha256 cellar: :any_skip_relocation, monterey:       "8df9f1fb49d97fc66419cc3b9d2449e8bea24ea01fc79989ffc969e3e9420031"
    sha256 cellar: :any_skip_relocation, big_sur:        "d04d0d44fd7ab2450d1c08c93a5826cc67f0e9762abacc87c79e4cc19ac42ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90d094304d11d03e12b5323ad02a926130f1984b08201c129705f2bccad6b5a7"
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
