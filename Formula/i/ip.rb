class Ip < Formula
  desc "Display public and private IPs and city for active network interfaces"
  homepage "https://github.com/StarkChristmas/ipget"
  url "https://github.com/StarkChristmas/ipget/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0f1e6099eb568f3027db981177a1062c84036171cb13b697c38c992a81339ba0"
  license "MIT"
  head "https://github.com/StarkChristmas/ipget.git", branch: "main"

  depends_on "go" => :build

  on_macos do
    def install
      system "go", "build", *std_go_args, "."
    end

    test do
      output = shell_output("#{bin}/ip 2>&1")
      assert_match(/\d+\.\d+\.\d+\.\d+/, output)
      assert_equal 0, $CHILD_STATUS.exitstatus
    end

    def caveats
      <<~EOS
        This formula is only supported on macOS.
      EOS
    end
  end
end

