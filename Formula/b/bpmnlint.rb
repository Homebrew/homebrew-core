class Bpmnlint < Formula
  desc "Validate BPMN diagrams based on configurable lint rules"
  homepage "https://github.com/bpmn-io/bpmnlint"
  url "https://registry.npmjs.org/bpmnlint/-/bpmnlint-12.1.0.tgz"
  sha256 "6fbe02d26c2ec2592bbef5bd910b798e4d04e4e81482d090a78beddd814da9f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03d6cab7afc4c7e38fef6224dea03a52060af585bdaf37152582ddabbf30c60b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/bpmnlint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bpmnlint --version")

    system bin/"bpmnlint", "--init"
    assert_match "\"extends\": \"bpmnlint:recommended\"", (testpath/".bpmnlintrc").read

    (testpath/"diagram.bpmn").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" id="Definitions_1">
        <bpmn:process id="Process_1" isExecutable="false">
          <bpmn:startEvent id="StartEvent_1"/>
        </bpmn:process>
      </bpmn:definitions>
    XML

    output = shell_output("#{bin}/bpmnlint diagram.bpmn 2>&1", 1)
    assert_match "Process_1     error  Process is missing end event   end-event-required", output
  end
end
