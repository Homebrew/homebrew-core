class Honcho < Formula
  include Language::Python::Virtualenv

  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://files.pythonhosted.org/packages/0e/7c/c0aa47711b5ada100273cbe190b33cc12297065ce559989699fd6c1ec0cb/honcho-1.1.0.tar.gz"
  sha256 "c5eca0bded4bef6697a23aec0422fd4f6508ea3581979a3485fc4b89357eb2a9"
  license "MIT"
  head "https://github.com/nickstenning/honcho.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d21e8703c2846aa6b06d9527f33db86ecaeed03ed7a9ea63b0553de9f5979087"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30fba81633706ff659426883e4f46d8c631a98f5214623e1b8ff60c269a7df96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b91f4fe5644d5ee0c2fee58aaea8e3e3a04ae1076a3fcd093080d5d389623991"
    sha256 cellar: :any_skip_relocation, sonoma:         "f306f3cb168953c490d20c015d0ccd0cef3bc9edb56c645f5dfd2174d993dcf4"
    sha256 cellar: :any_skip_relocation, ventura:        "d4665935a11af44420a3c3abe26b61257ae9cffc2b029d55ccde7311884bcd3a"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6ce50a9f87ae0b59268aefdb82c53a86779aac90bec3ce7f1178a8d4418e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e197e7a87627ce248de6f4e102330b27ce6a38d62a0d5edc8f2030139f589356"
  end

  depends_on "python@3.12"

  # Replace pkg_resources with importlib for 3.12
  # https://github.com/nickstenning/honcho/pull/236
  patch do
    url "https://github.com/nickstenning/honcho/commit/ce96b41796ad3072abc90cfab857063a0da4610f.patch?full_index=1"
    sha256 "a20f222f57d23f33e732cc23ba4cc22000eb38e2f9cd5c71fdbc6321e0eb364f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Procfile").write("talk: echo $MY_VAR")
    (testpath/".env").write("MY_VAR=hi")
    assert_match(/talk\.\d+ \| hi/, shell_output("#{bin}/honcho start"))
  end
end
