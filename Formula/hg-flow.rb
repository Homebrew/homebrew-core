class HgFlow < Formula
  desc "Development model for mercurial inspired by git-flow"
  homepage "https://bitbucket.org/yujiewu/hgflow"
  url "https://bitbucket.org/yujiewu/hgflow/downloads/hgflow-v0.9.8.2.tar.bz2"
  sha256 "ff62ce57126cf0f932dc9da13d3eaed11db6ebb782580c851b072f4fe58dc399"
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
