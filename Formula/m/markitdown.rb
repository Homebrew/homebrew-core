class Markitdown < Formula
  include Language::Python::Virtualenv

  desc "Utility tool for converting various files to Markdown"
  homepage "https://github.com/microsoft/markitdown"
  url "https://files.pythonhosted.org/packages/83/93/3b93c291c99d09f64f7535ba74c1c6a3507cf49cffd38983a55de6f834b6/markitdown-0.1.5.tar.gz"
  sha256 "4c956ff1528bf15e1814542035ec96e989206d19d311bb799f4df973ecafc31a"
  license "MIT"

  depends_on "python-gdbm@3.13"
  depends_on "python@3.13"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/82/f3/748f4d6f65d1756b9ae577f329c951cda23fb900e4de9f70900ced962085/setuptools-82.0.0.tar.gz"
    sha256 "22e0a2d69474c6ae4feb01951cb69d515ed23728cf96d05513d36e42b62b37cb"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/89/24/a2eb353a6edac9a0303977c4cb048134959dd2a51b48a269dfc9dde00c8a/wheel-0.46.3.tar.gz"
    sha256 "e3e79874b07d776c40bd6033f8ddf76a7dad46a7b8aa1b2787a83083519a1803"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/4f/a4/00a9ac1b555294710d4a68d2ce8dfdf39d72aa4d769a7395d05218d88a42/setuptools_scm-8.1.0.tar.gz"
    sha256 "42dea1b65771cba93b7a515d65a65d8246e560768a66b9106a592c8e7f26c8a7"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/cf/9c/b4cfe330cd4f49cff17fd771154730555fa4123beb7f292cf0098b4e6c20/hatchling-1.29.0.tar.gz"
    sha256 "793c31816d952cee405b83488ce001c719f325d9cda69f1fc4cd750527640ea6"
  end

  resource "editables" do
    url "https://files.pythonhosted.org/packages/37/4a/986d35164e2033ddfb44515168a281a7986e260d344cf369c3f52d4c3275/editables-0.5.tar.gz"
    sha256 "309627d9b5c4adc0e668d8c6fa7bac1ba7c8c5d415c2d27f60f081f8e80d1de2"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/d8/43/7935f8ea93fcb6680bc10a6fdbf534075c198eeead59150dd5ed68449642/trove_classifiers-2026.1.14.14.tar.gz"
    sha256 "00492545a1402b09d4858605ba190ea33243d361e2b01c9c296ce06b5c3325f3"
  end

  resource "magika" do
    url "https://files.pythonhosted.org/packages/12/46/b8180a34c64470e2f40a3676ef3284a32efd2b3598aa99946ee319eb66e8/magika-1.0.2-py3-none-any.whl"
    sha256 "c50be7a6a7132ef1a92956694401aaf911bda8fc5e2a591092e0dac5b5865a8a"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/a2/8c/58f469717fa48465e4a50c014a0400602d3c437d7c0c468e17ada824da3a/certifi-2025.11.12.tar.gz"
    sha256 "d8ab5478f2ecd78af242878415affce761ca6bc54a22a27e026d7c25357c3316"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "cobble" do
    url "https://files.pythonhosted.org/packages/54/7a/a507c709be2c96e1bb6102eb7b7f4026c5e5e223ef7d745a17d239e9d844/cobble-0.1.4.tar.gz"
    sha256 "de38be1539992c8a06e569630717c485a5f91be2192c461ea2b220607dfa78aa"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "mammoth" do
    url "https://files.pythonhosted.org/packages/ed/3c/a58418d2af00f2da60d4a51e18cd0311307b72d48d2fffec36a97b4a5e44/mammoth-1.11.0.tar.gz"
    sha256 "a0f59e442f34d5b6447f4b0999306cbf3e67aaabfa8cb516f878fb1456744637"
  end

  resource "markdownify" do
    url "https://files.pythonhosted.org/packages/3f/bc/c8c8eea5335341306b0fa7e1cb33c5e1c8d24ef70ddd684da65f41c49c92/markdownify-1.2.2.tar.gz"
    sha256 "b274f1b5943180b031b699b199cbaeb1e2ac938b75851849a31fd0c3d6603d09"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "flatbuffers" do
    url "https://files.pythonhosted.org/packages/e8/2d/d2a548598be01649e2d46231d151a6c56d10b964d94043a335ae56ea2d92/flatbuffers-25.12.19-py2.py3-none-any.whl"
    sha256 "7634f50c427838bb021c2d66a3d1168e9d199b0607e6329399f04846d42e20b4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b7/b9/c538f279a4e237a006a2c98387d081e9eb060d203d8ed34467cc0f0b9b53/packaging-26.0-py3-none-any.whl"
    sha256 "b36f1fef9334a5588b4166f8bcd26a14e521f2b55e6b9de3aaa80d3ff7a37529"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/a4/e7/14dc9366696dcb53a413449881743426ed289d687bcf3d5aee4726c32ebb/protobuf-7.34.0-py3-none-any.whl"
    sha256 "e3b914dd77fa33fa06ab2baa97937746ab25695f389869afdf03e81f34e45dc7"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/a2/09/77d55d46fd61b4a135c444fc97158ef34a095e5681d0a6c10b75bf356191/sympy-1.14.0-py3-none-any.whl"
    sha256 "e091cc3e99d2141a0ba2847328f5479b05d94a6635cb96148ccb3f34671bd8f5"
  end

  resource "onnxruntime" do
    url "https://github.com/microsoft/onnxruntime/archive/refs/tags/v1.24.2.tar.gz"
    sha256 "e4f44579f0bdd06d1cc7abdb2a6740dc06ac10699d502c0f8d9576203550bd4d"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    (testpath/"test.csv").write <<~CSV
      name,age
      Alice,30
      Bob,25
    CSV
    output = shell_output("#{bin}/markitdown test.csv")
    assert_match "| name | age |", output
    assert_match "| Alice | 30 |", output
  end
end
