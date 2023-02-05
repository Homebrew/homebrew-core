class Kush < Formula
  desc "Cross-platform command-line SSH remote address connection tool"
  homepage "https://github.com/anigkus/kush"
  url "https://github.com/anigkus/kush/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "865402e6672112900b686f5f2647485f576c7cda71089c90f4e453dca0c8b059"
  license "Apache-2.0"
  head "https://github.com/anigkus/kush.git"
  depends_on "go" => :build
  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"kush", "completion")
  end
  test do
    output = shell_output("#{bin}/kush version")
    assert_match "Version:    #{version}", output
  end
end
