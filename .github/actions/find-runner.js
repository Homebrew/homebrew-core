const { Octokit } = require("@octokit/action");

const octokit = new Octokit();

get_async()

async function get_async () {
  const data = await octokit.request('GET /repos/Homebrew/homebrew-core/actions/runners')
  console.log("Result: %s", data);
}