class Gruyere < Formula
  include Language::Python::Virtualenv

  desc "TUI program for viewing and killing processes listening on ports"
  homepage "https://github.com/savannahostrowski/gruyere"
  url "https://files.pythonhosted.org/packages/16/0f/d951dda46ba3b3dcbdf14f55355130b016445f9aa6b021dd70a9a567026a/gruyere-0.1.0.tar.gz"
  sha256 "3fe1ff4eef9a53ed46f17a7aa5efa2eb0212a2c6de618c2b36735bcc71d358be"
  license "MIT"
  revision 2
  head "https://github.com/savannahostrowski/gruyere.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29df3928d4b89687abd7224e4cbd7c19692778c9d08bf1afefbce80d095a4ff0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c4d5ae61a3f7fcd00615d8e01f5b0ebda1e01ebaf4d7abe7d4886342cb61c0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a4150f9847075ec44ebcadcbae7b97af323b24e9e0fcdcc95b261c3faa07e30"
    sha256 cellar: :any,                 arm64_linux:       "3e7f0b024ffd48db8545ee0110b6d25a84e1179e981bf39f188a9c68b262aaa9"
    sha256 cellar: :any,                 x86_64_linux:      "c7ec88491a3e5549e9df176fe92636c3d956fed81c6624ca4318d5f78e75dc04"
  end

  depends_on "python@3.15"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/ed/49/a10341024c45bed95d13197ec9ef0f4e2fd10b5ca6e7f8d7684d18082398/readchar-4.2.2.tar.gz"
    sha256 "e3b270fe16fc90c50ac79107700330a133dd4c63d22939f5b03b4f24564d5dd8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/03/51/d33db42cc72ffd8c30777547b42d01f0cbf9d95a770457698d0174b3ed71/typer-0.27.3.tar.gz"
    sha256 "d0396f770a560ab1b0a8504e13b5f254b728cedb05c61cf0359e944e50ce8901"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"gruyere", shell_parameter_format: :typer)
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"gruyere", "--details", [:out, :err] => output_log.to_s
    sleep 4
    assert_match "Here's what's running...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
