class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https://github.com/jorgebucaran/fisher"
  url "https://github.com/jorgebucaran/fisher/archive/refs/tags/4.4.4.tar.gz"
  sha256 "856e490e35cb9b1f1f02d54c77c6f4e86eb6f97fb5cfd8883a9df7b1d148a8e6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1a8d7644b008b6c42fc245366f11a8a5a13c95adc180816e82e366874f08092"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1a8d7644b008b6c42fc245366f11a8a5a13c95adc180816e82e366874f08092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1a8d7644b008b6c42fc245366f11a8a5a13c95adc180816e82e366874f08092"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1a8d7644b008b6c42fc245366f11a8a5a13c95adc180816e82e366874f08092"
    sha256 cellar: :any_skip_relocation, ventura:        "a1a8d7644b008b6c42fc245366f11a8a5a13c95adc180816e82e366874f08092"
    sha256 cellar: :any_skip_relocation, monterey:       "a1a8d7644b008b6c42fc245366f11a8a5a13c95adc180816e82e366874f08092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8b727116c5d988b083398fc3fb250a104a9525d20bb063fa8901975f331dea7"
  end

  depends_on "fish"

  def install
    fish_function.install "functions/fisher.fish"
    fish_completion.install "completions/fisher.fish"
  end

  test do
    system "#{Formula["fish"].bin}/fish", "-c", "fisher install jethrokuan/z"
    assert_equal File.read(testpath/".config/fish/fish_plugins"), "jethrokuan/z\n"
  end
end
