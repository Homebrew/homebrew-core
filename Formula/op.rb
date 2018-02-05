class Op < Formula
  desc "CLI for 1password.com"
  homepage "https://support.1password.com/command-line-getting-started/"
  url "https://cache.agilebits.com/dist/1P/op/pkg/v0.2.1/op_darwin_amd64_v0.2.1.zip"
  sha256 "fd15c2c0e429623e3d0bff17f7f94867cd5d8b55d10f69076c2ec277da755d77"

  def install
    bin.install "op"
  end

  test do
    # 'op -version' exits with status 1, rather than 0
    assert_match version.to_s, shell_output("#{bin}/op --version", 1)
  end
end
