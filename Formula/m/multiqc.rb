class Multiqc < Formula
  include Language::Python::Virtualenv

  desc "Aggregate bioinformatics analysis results across many samples into one report"
  homepage "https://multiqc.info/"
  url "https://files.pythonhosted.org/packages/af/a2/90e1b19ee65ec2619a4ff1767deefe32ba16c87f1363864778bd97ee5800/multiqc-1.35.tar.gz"
  sha256 "5a4aa6480e6def2f9c0af2893358bf7ec5c304d606ecf613cd25ddcd0e244e77"
  license "GPL-3.0-or-later"
  head "https://github.com/MultiQC/MultiQC.git", branch: "main"

  depends_on "cmake" => :build # for pyarrow
  depends_on "ninja" => :build # for pyarrow
  depends_on "rust" => :build # for polars, tiktoken
  depends_on "apache-arrow"
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  # kaleido 0.2.1 (MIT, pinned by multiqc) has no sdist on PyPI as its wheels bundle Chromium;
  # it is only needed to export static plot images
  pypi_packages exclude_packages: %w[certifi kaleido==0.2.1 numpy pillow polars-runtime-compat pydantic rpds-py]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/c8/0a/e4f8bc0cfa5822cacfd01d7be0e991faa3405440248d7db338efe11b6daa/boto3-1.43.126.tar.gz"
    sha256 "5fda4a3dd2782c134a01d1678911962c2860dd8de8cd10bef168ba1507b371a9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/69/3d/c76e2be7d71ed9e47d5b27f735443fca7bdbb330bae3c8da88fd19846495/botocore-1.43.126.tar.gz"
    sha256 "96996af07d8b703c3cdf44863f69c0b4b8b2d1cb6976c641986ced3e38c072f3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "colormath2" do
    url "https://files.pythonhosted.org/packages/a0/d2/ffc1354bdb2e5aa2772782bd34351caf2e98ef2a0850080feda4216178d9/colormath2-3.0.3.tar.gz"
    sha256 "e797613f4f0b86c6c218a1c7dc50f1259e6934e391581969b689ae27379c2ffa"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/98/f6/4eda8458eb00ec03e715c376c6b23b3def69687924c68d36d1c4003d3bc4/importlib_metadata-10.1.0.tar.gz"
    sha256 "82b04047fa09792c1a8cfeddfe08bec79e4b13c29c8469b0d3949860f61017e8"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/ca/eb/dc0fd6eff604bfb870b7fb68b90985a32caaf3c76f67736bbf7f438acd59/markdown-3.11.3.tar.gz"
    sha256 "81eb91631dc97ad1efbc76019ef0f80fe90ca49ddf81546752d79989c3bfff3e"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "narwhals" do
    url "https://files.pythonhosted.org/packages/67/43/e11d75a7fb635c6f63dd6e176cb3e050ec2fee35f2f2267b332a6ad351ec/narwhals-2.28.0.tar.gz"
    sha256 "2d9860c80d6610820826e94c6e42ce4b1d92d89cdd479586e652a8d211dab345"
  end

  resource "natsort" do
    url "https://files.pythonhosted.org/packages/e2/a9/a0c57aee75f77794adaf35322f8b6404cbd0f89ad45c87197a937764b7d0/natsort-8.4.0.tar.gz"
    sha256 "45312c4a0e5507593da193dedd04abb1469253b601ecaf63445ad80f0a1ea581"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/dc/76/3af777226b63a5e64a6b36b1ec5855c14e2b94a37096d4760e595fc43511/networkx-3.7.tar.gz"
    sha256 "fd77a511bd90f39f3d016351345b52cf5319b813bdca01de3f755d3cca62e96a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/49/c3/72b369f5ed7701b04ab0ea3dcf83e9bbce71c0b3bc6f07f87568550d09ea/plotly-7.1.0.tar.gz"
    sha256 "f860166a4a3d78c69cb1f4a15f28a5c8283eade98a282a698f3bb853a449ace5"
  end

  resource "polars" do
    url "https://files.pythonhosted.org/packages/b9/da/c27daf205a824f89f71172a75ad0098c5837a5a31ddeaac7f8737ea8574b/polars-2.1.0.tar.gz"
    sha256 "9eee488d6e10773c028753dfc8dac647fd60a708108dcb818a733e85d33df253"
  end

  resource "polars-runtime-32" do
    url "https://files.pythonhosted.org/packages/e0/a6/46e09af693326735b1fba3a8bf5a725b57136fb1342e707e75d3113c826b/polars_runtime_32-2.1.0.tar.gz"
    sha256 "c575f5f3cdb8a5f9be65477b9b4202b062593687fe62a0082add87fbd4571067"
  end

  resource "pyarrow" do
    url "https://files.pythonhosted.org/packages/bc/5e/9cb2a56d5e293aab4e2fbecc5b0620d93227d66b8d5a63c554c31e1f80fe/pyarrow-26.0.1.tar.gz"
    sha256 "93affcbd8a343e98dc19e9ec8fe17271ebf8fe98102d8b7454175074409f8b72"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/72/b0/978240b60eda8747b90ab206b6c531c4c1d2b98fcf6640ce4e4c4f07256e/regex-2026.11.8.tar.gz"
    sha256 "8098dc356ade739d2500460d1fcb5eb5bcd4fd2293ac42a26cdaebeb734c1548"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/96/3e/5688fdd83aea416de336582a274f2bc8236b5c261b04c11e17bc262786ad/rich_click-1.9.9.tar.gz"
    sha256 "324cba7513cd4187ee92b2eef21f071714e45be062458c8b157bd7e0c81103e3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "spectra" do
    url "https://files.pythonhosted.org/packages/68/1b/23c9c5c8f60fa8d5a4585448e958b6b68f4d69255f50d2d9c2f13b8bc8c1/spectra-0.1.0.tar.gz"
    sha256 "6a30e33241cb18256020395181cb4cc029dcac6de6f8d78cecbed81c14226a3f"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/66/62/167a842aa0429d45f5e797354fd4343a96f6043d67d0513c675c7b8d36e6/tiktoken-0.14.0.tar.gz"
    sha256 "231dec90efcdccf1b565a1416107736f1e09b1a08fe736ef9d6363e626d03874"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/b4/de/4420db493fa8fc0856d5e5c1b159c63a323d2de2317babe36b01568928e8/typeguard-4.6.0.tar.gz"
    sha256 "e7414f09111317de3e335de92cd397c5c0ca00b1cc1676de12e1d444a79b3f21"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/18/05/ba1458dee0ac485b2a01071c1b88f5199fe878a485df482e10e1ef2205cc/zipp-4.1.2.tar.gz"
    sha256 "cf474b90b07ea932637e17c6b9479de2b2882900b0d311bdaf4f5c000a15a97f"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"

    venv = virtualenv_install_with_resources(without: "polars-runtime-32")

    # polars enables its `nightly` feature by default, which needs a nightly compiler.
    # Disable LTO and debug info to reduce peak memory usage when linking the large extension.
    with_env(CARGO_PROFILE_RELEASE_DEBUG: "false",
             CARGO_PROFILE_RELEASE_LTO:   "false",
             MATURIN_PEP517_ARGS:         "--no-default-features --features full") do
      venv.pip_install resource("polars-runtime-32")
    end

    generate_completions_from_executable(bin/"multiqc", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multiqc --version")

    (testpath/"sample1.flagstat").write <<~EOS
      100 + 0 in total (QC-passed reads + QC-failed reads)
      100 + 0 primary
      0 + 0 secondary
      0 + 0 supplementary
      0 + 0 duplicates
      0 + 0 primary duplicates
      95 + 0 mapped (95.00% : N/A)
      95 + 0 primary mapped (95.00% : N/A)
      100 + 0 paired in sequencing
      50 + 0 read1
      50 + 0 read2
      90 + 0 properly paired (90.00% : N/A)
      94 + 0 with itself and mate mapped
      1 + 0 singletons (1.00% : N/A)
      0 + 0 with mate mapped to a different chr
      0 + 0 with mate mapped to a different chr (mapQ>=5)
    EOS

    system bin/"multiqc", testpath, "--outdir", testpath/"out"
    assert_path_exists testpath/"out/multiqc_report.html"
    assert_match "sample1", (testpath/"out/multiqc_data/multiqc_samtools_flagstat.txt").read
  end
end
