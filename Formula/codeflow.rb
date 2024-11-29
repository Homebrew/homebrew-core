class Codeflow < Formula
  desc "Tool for dynamic text-based content display and interaction"
  homepage "https://github.com/han-nwin/codeflow"
  url "https://github.com/han-nwin/codeflow/releases/download/v1.0.0/codeflow-mac.tar.gz"
  sha256 "3a1e00f669b38801adc1f5f4ef13efdd21be3bd40cf9bb3cd9fa2b5ed8f77dea"
  license "MIT"

  def install
    bin.install "codeflow-mac" => "codeflow"
  end

  test do
    assert_match "codeflow version 1.0.0", shell_output("#{bin}/codeflow -version")
  end
end
