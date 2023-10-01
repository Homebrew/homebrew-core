class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v9.1.0.tar.gz"
  sha256 "48306496413c61d37eeaa0a7328a4520b1da0c42739e046f6f9242de0d0ae270"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c4d14260d7c3b42b710dc9450f63424394c31e1afdb87b06f2dab1218daffa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46e0df0a9d89cb3c6b2c35a9cbc10ca5045c0f557c901bd42ff2f63753963bea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46e0df0a9d89cb3c6b2c35a9cbc10ca5045c0f557c901bd42ff2f63753963bea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46e0df0a9d89cb3c6b2c35a9cbc10ca5045c0f557c901bd42ff2f63753963bea"
    sha256 cellar: :any_skip_relocation, sonoma:         "8dc9356514c5a778980ec29eec21e6d9e789c9df2ed6f2cd10701a2e51b4666d"
    sha256 cellar: :any_skip_relocation, ventura:        "6a1f859bc51abb5947553cbb86c9c191f0160e211b6938dd18182a2a9f1d66e7"
    sha256 cellar: :any_skip_relocation, monterey:       "6a1f859bc51abb5947553cbb86c9c191f0160e211b6938dd18182a2a9f1d66e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a1f859bc51abb5947553cbb86c9c191f0160e211b6938dd18182a2a9f1d66e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e0df0a9d89cb3c6b2c35a9cbc10ca5045c0f557c901bd42ff2f63753963bea"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
