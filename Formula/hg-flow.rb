class HgFlow < Formula
  desc "Development model for mercurial inspired by git-flow"
  homepage "https://bitbucket.org/yujiewu/hgflow"
  url "https://bitbucket.org/yujiewu/hgflow/downloads/hgflow-v0.9.8.3.tar.bz2"
  sha256 "13ded94841185925f709481d2f2dd6fb10cd0c0c6f5b898c4ae97ac2636509a9"
  head "https://bitbucket.org/yujiewu/hgflow", :using => :hg, :branch => "develop"

  bottle :unneeded

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on :hg

  def install
    if build.head?
      libexec.install "src/hgflow.py" => "hgflow.py"
    else
      libexec.install "hgflow.py"
    end
  end

  def caveats; <<~EOS
    1. Put following lines into your ~/.hgrc
    2. Restart your shell and try "hg flow".
    3. For more information go to https://bitbucket.org/yinwm/hgflow

        [extensions]
        flow = #{opt_libexec}/hgflow.py
        [flow]
        autoshelve = true

    EOS
  end

  test do
    (testpath/".hgrc").write <<~EOS
      [extensions]
      flow = #{opt_libexec}/hgflow.py
      [flow]
      autoshelve = true
    EOS
    system "hg", "init"
    system "hg", "flow", "init", "-d"
  end
end
